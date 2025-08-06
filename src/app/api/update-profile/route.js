import { NextResponse } from 'next/server';
import { PrismaClient } from '@prisma/client';
import { verifyToken } from '@/lib/(back-end)/auth';
import fs from 'fs';
import path from 'path';

export const runtime = 'nodejs'; // ✅ Wajib agar support file upload
const prisma = new PrismaClient();

export async function PUT(req) {
  try {
    // ✅ Verifikasi token
    const authHeader = req.headers.get("authorization");
    const user = verifyToken(authHeader);
    if (!user) {
      return NextResponse.json({ message: "Unauthorized" }, { status: 401 });
    }

    // ✅ Ambil formData (tanpa formidable)
    const formData = await req.formData();
    const nm_lengkap = formData.get("nm_lengkap");
    const email = formData.get("email");
    const username = formData.get("username");
    const foto = formData.get("foto");

    if (!nm_lengkap || !email || !username) {
      return NextResponse.json({ message: "All fields are required" }, { status: 400 });
    }

    // ✅ Simpan foto jika ada
    let fotoPath = null;
    if (foto && typeof foto === "object" && foto.name) {
      const uploadDir = path.join(process.cwd(), "public", "uploads");
      if (!fs.existsSync(uploadDir)) fs.mkdirSync(uploadDir, { recursive: true });

      const filePath = path.join(uploadDir, foto.name);
      const buffer = Buffer.from(await foto.arrayBuffer());
      fs.writeFileSync(filePath, buffer);

      fotoPath = `/uploads/${foto.name}`;
    }

    // ✅ Cek duplikat email/username
    const duplicate = await prisma.user.findFirst({
      where: {
        AND: [
          { id_user: { not: user.userId } },
          { OR: [{ email }, { username }] },
        ],
      },
    });
    if (duplicate) {
      return NextResponse.json({ message: "Email or username already in use" }, { status: 409 });
    }

    // ✅ Update user di database
    const updatedUser = await prisma.user.update({
      where: { id_user: user.userId },
      data: {
        nm_lengkap,
        email,
        username,
        ...(fotoPath && { foto: fotoPath }),
      },
    });

    return NextResponse.json({
      message: "Profile updated successfully",
      data: {
        id: updatedUser.id_user,
        email: updatedUser.email,
        username: updatedUser.username,
        nm_lengkap: updatedUser.nm_lengkap,
        foto: updatedUser.foto
      }
    });

  } catch (error) {
    console.error("Update profile error:", error);
    return NextResponse.json({ message: "Internal Server Error" }, { status: 500 });
  }
}

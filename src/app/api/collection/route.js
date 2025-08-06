import prisma from "@/lib/prisma";
import { verifyToken } from "@/lib/(back-end)/auth";

export const dynamic = "force-dynamic";

// ✅ Ambil semua koleksi user
export async function GET(request) {
  try {
    const authHeader = request.headers.get("authorization");
    const user = verifyToken(authHeader);

    const books = await prisma.collection.findMany({
      where: { id_user: user.userId },
    });

    return Response.json({ code: 200, message: "Berhasil ambil koleksi", data: books });
  } catch (error) {
    const status = error.message.includes("Unauthorized") ? 401 : 500;
    return Response.json({ code: status, message: error.message }, { status });
  }
}

// ✅ Tambah buku ke koleksi user
export async function POST(request) {
  try {
    const authHeader = request.headers.get("authorization");
    const user = verifyToken(authHeader);

    const body = await request.json();
    const { id_book, title, description, thumbnail } = body;

    const newBook = await prisma.collection.create({
      data: {
        id_user: user.userId,
        id_book,
        title,
        description,
        thumbnail,
      },
    });

    return Response.json({ code: 200, message: "Berhasil tambah buku", data: newBook });
  } catch (error) {
    const status = error.message.includes("Unauthorized") ? 401 : 500;
    return Response.json({ code: status, message: error.message }, { status });
  }
}

// ✅ Hapus buku dari koleksi
export async function DELETE(request) {
  try {
    const authHeader = request.headers.get("authorization");
    console.log("DEBUG AUTH HEADER:", authHeader);

    const user = verifyToken(authHeader);
    const body = await request.json().catch(err => { 
      console.error("DEBUG BODY PARSE ERROR:", err);
      return {};
    });

    console.log("DEBUG DELETE BODY:", body);

    const { id_book } = body;

    if (!id_book) {
      return Response.json({ code: 400, message: "id_book required" }, { status: 400 });
    }

    const existing = await prisma.collection.findFirst({
      where: { id_book, id_user: user.userId },
    });

    if (!existing) {
      return Response.json({ code: 404, message: "Book not found" }, { status: 404 });
    }

    await prisma.collection.deleteMany({
      where: { id_book, id_user: user.userId },
    });

    return Response.json({ code: 200, message: "Berhasil hapus buku" });
  } catch (error) {
    console.error("DELETE ERROR", error);
    return Response.json({ code: 500, message: error.message }, { status: 500 });
  }
}



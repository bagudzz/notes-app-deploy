import { NextResponse } from "next/server";
import jwt from "jsonwebtoken";
import prisma from "@/lib/prisma";

const SECRET_KEY = process.env.SECRET_KEY_JWT;

export async function GET(req) {
  try {
    const authHeader = req.headers.get("authorization");
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      return NextResponse.json({ message: "Unauthorized" }, { status: 401 });
    }

    const token = authHeader.split(" ")[1];
    const decoded = jwt.verify(token, SECRET_KEY);

    const user = await prisma.user.findUnique({
      where: { id_user: decoded.userId },
      select: { id_user: true, username: true, email: true }
    });

    if (!user) {
      return NextResponse.json({ message: "User not found" }, { status: 404 });
    }

    return NextResponse.json({ code: 200, data: user });
  } catch (error) {
    return NextResponse.json({ message: "Error: " + error.message }, { status: 500 });
  }
}

import { NextResponse } from 'next/server';
import { PrismaClient } from '@prisma/client';
import { verifyToken } from '@/lib/(back-end)/auth';

const prisma = new PrismaClient();


export async function PUT(req) {
    try {
        console.log("OKEE LEE")
        const { nm_lengkap, email, username } = await req.json();
        const authHeader = req.headers.get("authorization");

        const user = verifyToken(authHeader)

        if (!nm_lengkap || !email || !username) {
            return NextResponse.json({ message: 'All fields are required' }, { status: 400 });
        }

        // Cek apakah email atau username sudah digunakan oleh user lain
        const duplicate = await prisma.user.findFirst({
            where: {
                AND: [
                    { id_user: { not: user.userId } },
                    {
                        OR: [
                            { email: email },
                            { username: username }
                        ]
                    }
                ]
            }
        });

        if (duplicate) {
            return NextResponse.json({ message: 'Email or username already in use by another user' }, { status: 409 });
        }

        const updatedUser = await prisma.user.update({
            where: { id_user: user.userId },
            data: {
                nm_lengkap,
                email,
                username,
            },
        });

        return NextResponse.json({
            message: 'Profile updated successfully',
            data: {
                id: updatedUser.id_user,
                email: updatedUser.email,
                username: updatedUser.username,
                nm_lengkap: updatedUser.nm_lengkap,
            },
        });
    } catch (error) {
        console.error('Update profile error:', error);
        return NextResponse.json({ message: 'Internal Server Error' }, { status: 500 });
    }
}
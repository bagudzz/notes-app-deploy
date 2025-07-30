/*
  Warnings:

  - You are about to drop the `notes` table. If the table is not empty, all the data it contains will be lost.

*/
-- CreateSchema
CREATE SCHEMA IF NOT EXISTS "tugas-akhir";

-- DropTable
DROP TABLE "notes"."notes";

-- CreateTable
CREATE TABLE "notes"."Notes" (
    "id_notes" VARCHAR(255) NOT NULL DEFAULT public.uuid_generate_v4(),
    "id_user" TEXT,
    "title" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Notes_pkey" PRIMARY KEY ("id_notes")
);

-- CreateTable
CREATE TABLE "auth"."User" (
    "id_user" VARCHAR(255) NOT NULL DEFAULT public.uuid_generate_v4(),
    "nm_lengkap" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "username" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id_user")
);

-- CreateTable
CREATE TABLE "tugas-akhir"."ResultProject" (
    "id_project" VARCHAR(255) NOT NULL DEFAULT public.uuid_generate_v4(),
    "id_user" TEXT NOT NULL,
    "name_mhs" TEXT NOT NULL,
    "nim_mhs" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "profile_link" TEXT NOT NULL,
    "project_link" TEXT NOT NULL,
    "image_project_link" TEXT NOT NULL,
    "total_reviews" INTEGER NOT NULL DEFAULT 0,
    "average_score" DOUBLE PRECISION NOT NULL DEFAULT 0.0,

    CONSTRAINT "ResultProject_pkey" PRIMARY KEY ("id_project")
);

-- CreateTable
CREATE TABLE "tugas-akhir"."ReviewProject" (
    "id_review" VARCHAR(255) NOT NULL DEFAULT public.uuid_generate_v4(),
    "id_project" TEXT NOT NULL,
    "reviewer_id" TEXT NOT NULL,
    "score" INTEGER NOT NULL,
    "reviewed_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ReviewProject_pkey" PRIMARY KEY ("id_review")
);

-- CreateIndex
CREATE UNIQUE INDEX "unique_responsen_cuid" ON "notes"."Notes"("id_notes");

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "auth"."User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "User_username_key" ON "auth"."User"("username");

-- CreateIndex
CREATE UNIQUE INDEX "ResultProject_id_project_key" ON "tugas-akhir"."ResultProject"("id_project");

-- CreateIndex
CREATE UNIQUE INDEX "ResultProject_nim_mhs_key" ON "tugas-akhir"."ResultProject"("nim_mhs");

-- AddForeignKey
ALTER TABLE "notes"."Notes" ADD CONSTRAINT "Notes_id_user_fkey" FOREIGN KEY ("id_user") REFERENCES "auth"."User"("id_user") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tugas-akhir"."ResultProject" ADD CONSTRAINT "ResultProject_id_user_fkey" FOREIGN KEY ("id_user") REFERENCES "auth"."User"("id_user") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tugas-akhir"."ReviewProject" ADD CONSTRAINT "ReviewProject_reviewer_id_fkey" FOREIGN KEY ("reviewer_id") REFERENCES "auth"."User"("id_user") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tugas-akhir"."ReviewProject" ADD CONSTRAINT "ReviewProject_id_project_fkey" FOREIGN KEY ("id_project") REFERENCES "tugas-akhir"."ResultProject"("id_project") ON DELETE RESTRICT ON UPDATE CASCADE;

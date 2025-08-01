/*
  Warnings:

  - The primary key for the `Collection` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to drop the column `id` on the `Collection` table. All the data in the column will be lost.
  - Added the required column `description` to the `Collection` table without a default value. This is not possible if the table is not empty.
  - Added the required column `id_book` to the `Collection` table without a default value. This is not possible if the table is not empty.
  - Added the required column `thumbnail` to the `Collection` table without a default value. This is not possible if the table is not empty.
  - Added the required column `title` to the `Collection` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "auth"."User" ALTER COLUMN "id_user" SET DEFAULT public.uuid_generate_v4();

-- AlterTable
ALTER TABLE "collection"."Collection" DROP CONSTRAINT "Collection_pkey",
DROP COLUMN "id",
ADD COLUMN     "description" TEXT NOT NULL,
ADD COLUMN     "id_book" TEXT NOT NULL,
ADD COLUMN     "thumbnail" TEXT NOT NULL,
ADD COLUMN     "title" TEXT NOT NULL,
ADD CONSTRAINT "Collection_pkey" PRIMARY KEY ("id_book");

-- AlterTable
ALTER TABLE "notes"."Notes" ALTER COLUMN "id_notes" SET DEFAULT public.uuid_generate_v4();

-- AlterTable
ALTER TABLE "tugas-akhir"."ResultProject" ALTER COLUMN "id_project" SET DEFAULT public.uuid_generate_v4();

-- AlterTable
ALTER TABLE "tugas-akhir"."ReviewProject" ALTER COLUMN "id_review" SET DEFAULT public.uuid_generate_v4();

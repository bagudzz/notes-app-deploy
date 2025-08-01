/*
  Warnings:

  - Added the required column `id_user` to the `Collection` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "auth"."User" ALTER COLUMN "id_user" SET DEFAULT public.uuid_generate_v4();

-- AlterTable
ALTER TABLE "collection"."Collection" ADD COLUMN     "id_user" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "notes"."Notes" ALTER COLUMN "id_notes" SET DEFAULT public.uuid_generate_v4();

-- AlterTable
ALTER TABLE "tugas-akhir"."ResultProject" ALTER COLUMN "id_project" SET DEFAULT public.uuid_generate_v4();

-- AlterTable
ALTER TABLE "tugas-akhir"."ReviewProject" ALTER COLUMN "id_review" SET DEFAULT public.uuid_generate_v4();

-- AddForeignKey
ALTER TABLE "collection"."Collection" ADD CONSTRAINT "Collection_id_user_fkey" FOREIGN KEY ("id_user") REFERENCES "auth"."User"("id_user") ON DELETE RESTRICT ON UPDATE CASCADE;

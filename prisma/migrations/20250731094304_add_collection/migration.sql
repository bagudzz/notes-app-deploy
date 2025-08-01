-- CreateSchema
CREATE SCHEMA IF NOT EXISTS "collection";

-- AlterTable
ALTER TABLE "auth"."User" ALTER COLUMN "id_user" SET DEFAULT public.uuid_generate_v4();

-- AlterTable
ALTER TABLE "notes"."Notes" ALTER COLUMN "id_notes" SET DEFAULT public.uuid_generate_v4();

-- AlterTable
ALTER TABLE "tugas-akhir"."ResultProject" ALTER COLUMN "id_project" SET DEFAULT public.uuid_generate_v4();

-- AlterTable
ALTER TABLE "tugas-akhir"."ReviewProject" ALTER COLUMN "id_review" SET DEFAULT public.uuid_generate_v4();

-- CreateTable
CREATE TABLE "collection"."Collection" (
    "id" TEXT NOT NULL,

    CONSTRAINT "Collection_pkey" PRIMARY KEY ("id")
);

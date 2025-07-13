import { NextResponse } from "next/server";
import { fetchRedditPosts } from "@/lib/api-clients/reddit";

export async function GET() {
  const results = await fetchRedditPosts();
  return NextResponse.json({ message: "Hello, World!", data: results });
}

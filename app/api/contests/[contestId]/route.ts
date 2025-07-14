import { NextResponse } from "next/server";
import { fetchRedditPostById } from "@/lib/api-clients/reddit";

interface ContestPostParams {
  params: Promise<{
    contestId: string;
  }>;
}

export async function GET(request: Request, props: ContestPostParams) {
  const params = await props.params;
  const contestId = params.contestId;
  const results = await fetchRedditPostById(contestId);
  return NextResponse.json(results);
}

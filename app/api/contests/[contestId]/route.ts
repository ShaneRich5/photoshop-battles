import { NextResponse } from "next/server";
import { fetchRedditPostById } from "@/lib/api-clients/reddit";

interface ContestPostParams {
  params: {
    contestId: string;
  };
}

export async function GET(request: Request, { params }: ContestPostParams) {
  const contestId = params.contestId;
  return NextResponse.json({ contestId });
  // const results = await fetchRedditPostById(contestId);
  // return NextResponse.json(results);
}

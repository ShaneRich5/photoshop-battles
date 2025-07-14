import { NextResponse } from "next/server";

interface ContestPostParams {
  params: {
    contestId: string;
  };
}

export async function GET(request: Request, { params }: ContestPostParams) {
  // fetchRedditPostById()
  return NextResponse.json({
    message: "Hello, World!",
    contestId: params.contestId,
  });
}

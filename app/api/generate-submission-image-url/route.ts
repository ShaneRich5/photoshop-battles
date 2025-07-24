import { NextResponse, NextRequest } from "next/server";
import { fetchProcessedImageUrl } from "@/lib/api-clients/reddit";
import { computeUrlTypeFromImageUrl } from "@/lib/utils";

export async function GET(request: NextRequest) {
  const imageUrl = request.nextUrl.searchParams.get("imageUrl") || "";
  const urlType = computeUrlTypeFromImageUrl(imageUrl) ?? "";
  const processedImageUrl = await fetchProcessedImageUrl(imageUrl, urlType);

  return NextResponse.json({
    imageUrl,
    urlType,
    processedImageUrl,
  });
}

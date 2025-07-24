import {
  fetchAlbumImageUrl,
  fetchGalleryImageUrl,
  fetchSingleImageUrl,
} from "@/lib/api-clients/imgur";
import {
  generateUrlType,
  parseImageUrlFromRedditCommentBody,
  parseTextFromRedditCommentBody,
} from "@/lib/utils";

const PHOTOSHOP_BATTLES_ENDPOINT = "r/photoshopbattles";

interface Contest {
  id: string;
  title: string;
  imageUrl: string;
  permalink: string;
  upVoteCount: number;
  commentCount: number;
  author?: string; // Optional, as not all posts may have an author
}

const fetchWithHeaders = async (endpoint: string): Promise<Response> => {
  return fetch(`https://www.reddit.com/${endpoint}.json`, {
    headers: {
      "User-Agent":
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) RedditScraper/1.0",
    },
  });
};

const normalizeRedditPostListResponseToSummarizedContestList = (
  redditPostListResponse: any
): Contest[] => {
  return redditPostListResponse.data.children
    .map((postData: any) =>
      normalizeRedditPostDetailResponseToContestDetail(postData.data)
    )
    .filter((post: any) => post.title.startsWith("PsBattle:")); // the image URL is not always present, so we filter out posts that don't start with "PsBattle:"
};

export async function fetchRedditPosts() {
  const endpoint = `${PHOTOSHOP_BATTLES_ENDPOINT}`;
  const result = await fetchWithHeaders(endpoint);

  if (!result.ok) {
    const text = await result.text();
    console.error("Non-200 response:", result.status, text);
    return [];
  }

  const data = await result.json();
  return normalizeRedditPostListResponseToSummarizedContestList(data);
}

const normalizeRedditPostDetailResponseToContestDetail = (
  post: any
): Contest => ({
  id: post.id,
  title: post.title,
  imageUrl: post.url,
  author: post.author,
  upVoteCount: post.ups,
  permalink: post.permalink,
  commentCount: post.num_comments,
});

export async function fetchImageUrlForSubmission() {}

const buildDefaultSubmissionFromRedditComment = (comment: any) => {
  const body = comment.body ?? "";
  const title = parseTextFromRedditCommentBody(body);
  const imageUrl = parseImageUrlFromRedditCommentBody(body);
  const urlType = generateUrlType(title, imageUrl);

  return {
    id: comment.id,
    body,
    title,
    urlType,
    imageUrl,
    originalImageUrl: imageUrl,
    author: comment.author ?? null,
    permalink: comment.permalink ?? null,
    upvoteCount: comment.ups ?? null,
  };
};

export const convertImgurAlbumSubmissionToDirectLink = async (
  imageUrl: string
) => {
  const parts = imageUrl.split("/").pop() || "";
  const albumHash = parts.split("#")[0];
  return await fetchAlbumImageUrl(albumHash);
};

export const convertImgurGallerySubmissionToDirectLink = async (
  imageUrl: string
): Promise<string> => {
  let galleryHash = imageUrl.split("/").pop() || "";

  if (galleryHash.includes("-")) {
    const parts = galleryHash.split("-");
    if (parts.length > 1) {
      galleryHash = parts[parts.length - 1];
    }
  }

  return await fetchGalleryImageUrl(galleryHash);
};

export const convertImgurDirectSubmissionToDirectLink = async (
  imageUrl: string
): Promise<string> => {
  const imageHash = imageUrl.split("/").pop() ?? "";
  return await fetchSingleImageUrl(imageHash);
};

export const fetchProcessedImageUrl = async (
  imageUrl: string,
  urlType: string
) => {
  // Implement your image URL processing logic here
  try {
    if (urlType === "imgur-album") {
      return await convertImgurAlbumSubmissionToDirectLink(imageUrl);
    } else if (urlType === "imgur-gallery") {
      return await convertImgurGallerySubmissionToDirectLink(imageUrl);
    } else if (urlType === "imgur-direct") {
      return await convertImgurDirectSubmissionToDirectLink(imageUrl);
    } else if (urlType === "direct-link" || !imageUrl) {
      return Promise.resolve(imageUrl);
    }
  } catch (error) {
    console.error(
      `Error fetching ${urlType} image URL for submission: ${imageUrl}`,
      error
    );
  }

  return imageUrl;
};

const fetchAndAppendSubmissionImageUrl = async (
  submission: any
): Promise<any> => {
  const { imageUrl, urlType } = submission;

  try {
    if (urlType === "imgur-album") {
      return await convertImgurAlbumSubmissionToDirectLink(submission);
    } else if (urlType === "imgur-gallery") {
      return await convertImgurGallerySubmissionToDirectLink(submission);
    } else if (urlType === "imgur-direct") {
      return await convertImgurDirectSubmissionToDirectLink(submission);
    } else if (urlType === "direct-link" || !imageUrl) {
      return Promise.resolve(submission);
    }
  } catch (error) {
    console.error(
      `Error fetching ${urlType} image URL for submission: ${submission.id}`,
      error
    );
    return Promise.resolve(submission);
  }
  return Promise.resolve(submission);
};

export async function fetchRedditPostById(postId: string) {
  const url = `${PHOTOSHOP_BATTLES_ENDPOINT}/${postId}`;
  const result = await fetchWithHeaders(url);
  const response = await result.json();

  const postData = response[0];
  const commentData = response[1];

  const {
    data: {
      children: [{ data: post }],
    },
  } = postData;

  const contest = normalizeRedditPostDetailResponseToContestDetail(post);

  const {
    data: { children },
  } = commentData;

  const submissions = children
    .slice(1) // Skip the first comment which is usually the post itself
    .map((nestedData: any) => nestedData.data)
    .map((comment: any) => buildDefaultSubmissionFromRedditComment(comment));

  return { contest, submissions };
}

export async function fetchRedditContestDetailByPostId(postId: string) {
  const url = `${PHOTOSHOP_BATTLES_ENDPOINT}/${postId}`;
  const result = await fetchWithHeaders(url);
  console.log("reddit.ts) fetchRedditSubmissionListByPostId result:", result);
  const response = await result.json();
  console.log(
    "reddit.ts) fetchRedditSubmissionListByPostId response:",
    response
  );

  const postData = response[0];
  const commentData = response[1];

  console.log(
    "reddit.ts) fetchRedditSubmissionListByPostId commentData:",
    commentData
  );

  const {
    data: { children },
  } = commentData;

  console.log(
    "reddit.ts) fetchRedditSubmissionListByPostId children:",
    children
  );

  const unformattedSubmissions = children
    .map((nestedData: any) => nestedData.data)
    .map((comment: any) => buildDefaultSubmissionFromRedditComment(comment))
    .map((submission: any) => fetchAndAppendSubmissionImageUrl(submission))
    .slice(1);

  const submissions = await Promise.all(unformattedSubmissions);

  return {
    contest: normalizeRedditPostDetailResponseToContestDetail(postData.data),
    submissions,
  };
}

export async function fetchRedditSubmissionListByPostId(postId: string) {
  const url = `${PHOTOSHOP_BATTLES_ENDPOINT}/${postId}`;
  const result = await fetchWithHeaders(url);
  console.log("reddit.ts) fetchRedditSubmissionListByPostId result:", result);
  const response = await result.json();
  console.log(
    "reddit.ts) fetchRedditSubmissionListByPostId response:",
    response
  );
  const commentData = response[1];
  console.log(
    "reddit.ts) fetchRedditSubmissionListByPostId commentData:",
    commentData
  );

  const {
    data: { children },
  } = commentData;

  console.log(
    "reddit.ts) fetchRedditSubmissionListByPostId children:",
    children
  );

  const unformattedSubmissions = children
    .map((nestedData: any) => nestedData.data)
    .map((comment: any) => buildDefaultSubmissionFromRedditComment(comment))
    .map((submission: any) => fetchAndAppendSubmissionImageUrl(submission))
    .slice(1);

  return await Promise.all(unformattedSubmissions);
}

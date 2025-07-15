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
import axios from "axios";

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
      "User-Agent": "PhotoshopBattlesBot/0.1",
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
  const result = await axios.get(
    `https://www.reddit.com/${PHOTOSHOP_BATTLES_ENDPOINT}.json`,
    {
      headers: {
        "User-Agent": "PhotoshopBattlesBot/0.1",
      },
    }
  );

  if (result.status !== 200) {
    console.error("Non-200 response:", result.status, result.data);
    return [];
  }

  return normalizeRedditPostListResponseToSummarizedContestList(result.data);
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
    author: comment.author ?? null,
    permalink: comment.permalink ?? null,
    upvoteCount: comment.ups ?? null,
  };
};

export const convertImgurAlbumSubmissionToDirectLink = async (
  submission: any
): Promise<any> => {
  const { imageUrl } = submission;
  const albumHash = imageUrl.split("/").pop();
  const url = await fetchAlbumImageUrl(albumHash);

  return { ...submission, imageUrl: url };
};

export const convertImgurGallerySubmissionToDirectLink = async (
  submission: any
): Promise<any> => {
  const { imageUrl } = submission;
  const galleryHash = imageUrl.split("/").pop();
  const url = await fetchGalleryImageUrl(galleryHash);

  return { ...submission, imageUrl: url };
};

export const convertImgurDirectSubmissionToDirectLink = async (
  submission: any
): Promise<any> => {
  const { imageUrl } = submission;
  const imageHash = imageUrl.split("/").pop();
  const url = await fetchSingleImageUrl(imageHash);

  return { ...submission, imageUrl: url };
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
      `Error fetching image URL for submission: ${submission.id}`,
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

  const unformattedSubmissions = children
    .map((nestedData: any) => nestedData.data)
    .map((comment: any) => buildDefaultSubmissionFromRedditComment(comment))
    .map((submission: any) => fetchAndAppendSubmissionImageUrl(submission))
    .slice(1);

  const submissions = await Promise.all(unformattedSubmissions);

  return { contest, submissions };
}

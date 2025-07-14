const REDDIT_URL = "https://www.reddit.com";
const PHOTOSHOP_BATTLES_ENDPOINT = "/r/photoshopbattles";
const JSON_EXTENSION = ".json";

const normalizeRedditPostListResponseToContest = (
  redditPostListResponse: any
) => {
  return redditPostListResponse.data.children
    .map((post: any) => ({
      id: post.data.id,
      title: post.data.title,
      imageUrl: post.data.url,
      permanentLink: `https://www.reddit.com${post.data.permalink}`,
      upVoteCount: post.data.ups,
      commentCount: post.data.num_comments,
    }))
    .filter((post: any) => post.title.startsWith("PsBattle:")); // the image URL is not always present, so we filter out posts that don't start with "PsBattle:"
};

export async function fetchRedditPosts() {
  const url = `${REDDIT_URL}${PHOTOSHOP_BATTLES_ENDPOINT}${JSON_EXTENSION}`;
  const result = await fetch(url);
  const data = await result.json();
  return normalizeRedditPostListResponseToContest(data);
}

export async function fetchRedditPostById(postId: string) {
  const url = `${REDDIT_URL}${PHOTOSHOP_BATTLES_ENDPOINT}/${postId}${JSON_EXTENSION}`;
  const result = await fetch(url);
  return await result.json();
}

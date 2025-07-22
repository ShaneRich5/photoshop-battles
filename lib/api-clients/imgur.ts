import axios, { AxiosResponse } from "axios";

const IMGUR_URL = "https://api.imgur.com/3";

const imgurClient = axios.create({
  baseURL: IMGUR_URL,
  headers: {
    "Content-Type": "application/json",
    Authorization: `Client-ID ${process.env.NEXT_PUBLIC_IMGUR_CLIENT_ID}`,
  },
});

const parseJsonSafe = async (response: AxiosResponse) => {
  // const contentType = response.headers.get("content-type") || "";
  // if (!contentType.includes("application/json") || !response.ok) {
  //   const text = await response.text();
  //   throw new Error(
  //     `Expected JSON, got ${contentType}. Response snippet: ${text}`
  //   );
  // }
  // try {
  //   return response.json();
  // } catch {
  //   throw new Error(`Failed to parse JSON: ${response.statusText}`);
  // }
  return response.data;
};

const fetchWithHeaders = async (endpoint: string): Promise<AxiosResponse> => {
  // const defaultHeaders: HeadersInit = {
  //   "Content-Type": "application/json",
  //   Authorization: `Client-ID ${process.env.NEXT_PUBLIC_IMGUR_CLIENT_ID}`,
  // };

  // const mergedOptions: RequestInit = {
  //   ...options,
  //   headers: {
  //     ...defaultHeaders,
  //     ...(options.headers || {}),
  //   },
  // };

  // return fetch(`${IMGUR_URL}${endpoint}`, mergedOptions);

  try {
    return await imgurClient.get(endpoint);
  } catch (error) {
    console.error(`Error fetching from ${endpoint} Imgur:`, error);
    throw error;
  }
};

export const fetchAlbumImageUrl = async (
  albumHash: string
): Promise<string> => {
  const response = await fetchWithHeaders(`/album/${albumHash}/images`);

  const {
    data: [{ link }],
  } = await parseJsonSafe(response);
  return link;
};

export const fetchGalleryImageUrl = async (
  galleryHash: string
): Promise<string> => {
  const response = await fetchWithHeaders(
    `/gallery/album/${galleryHash}/images`
  );

  const jsonResult = await parseJsonSafe(response);

  const {
    data: [{ link }],
  } = jsonResult;
  return link;
};

export const fetchSingleImageUrl = async (
  imageHash: string
): Promise<string> => {
  const response = await fetchWithHeaders(`/image/${imageHash}`);

  const {
    data: { link },
  } = await parseJsonSafe(response);
  return link;
};

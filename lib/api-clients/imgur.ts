const IMGUR_URL = "https://api.imgur.com/3";

const fetchWithHeaders = async (
  endpoint: string,
  options: RequestInit = {}
): Promise<Response> => {
  const defaultHeaders: HeadersInit = {
    "Content-Type": "application/json",
    Authorization: `Client-ID ${process.env.NEXT_PUBLIC_IMGUR_CLIENT_ID}`,
  };

  const mergedOptions: RequestInit = {
    ...options,
    headers: {
      ...defaultHeaders,
      ...(options.headers || {}),
    },
  };

  return fetch(`${IMGUR_URL}${endpoint}`, mergedOptions);
};

export const fetchAlbumImageUrl = async (
  albumHash: string
): Promise<string> => {
  const response = await fetchWithHeaders(`/album/${albumHash}/images`);
  const {
    data: [{ link }],
  } = await response.json();
  return link;
};

export const fetchGalleryImageUrl = async (
  galleryHash: string
): Promise<string> => {
  const response = await fetchWithHeaders(
    `/gallery/album/${galleryHash}/images`
  );
  const jsonResult = await response.json();

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
  } = await response.json();
  return link;
};

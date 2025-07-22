const IMGUR_URL = "https://api.imgur.com/3";

const parseJsonSafe = async (response: Response) => {
  const contentType = response.headers.get("content-type") || "";
  if (!contentType.includes("application/json")) {
    const text = await response.text();
    throw new Error(
      `Expected JSON, got ${contentType}. Response snippet: ${text}`
    );
  }
  return response.json();
};

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

  if (!response.ok) {
    throw new Error(
      `Fetch failed with status ${response.status}: ${response.statusText}`
    );
  }

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

  if (!response.ok) {
    throw new Error(
      `Fetch failed with status ${response.status}: ${response.statusText}`
    );
  }

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

  if (!response.ok) {
    throw new Error(
      `Fetch failed with status ${response.status}: ${response.statusText}`
    );
  }

  const {
    data: { link },
  } = await parseJsonSafe(response);
  return link;
};

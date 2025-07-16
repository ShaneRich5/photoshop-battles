import { clsx, type ClassValue } from "clsx";
import { twMerge } from "tailwind-merge";

export const NOT_FOUND_INDEX = -1;
export const IMGUR_ALBUM_URL = "imgur.com/a/";
export const URL_WRAPPER_EXPRESSION = /\(.*?\)/;
export const TEXT_WRAPPER_EXPRESSION = /\[.*?\]/;

export const safelyParseWrappedText = (text: string, regex: RegExp) => {
  try {
    const match = text.match(regex);

    if (!match || match.length === 0) {
      return "";
    }

    const parsedText = match[0];
    return parsedText.slice(1, parsedText.length - 1);
  } catch {
    return "";
  }
};

export const parseTextFromRedditCommentBody = (body: string) =>
  safelyParseWrappedText(body, TEXT_WRAPPER_EXPRESSION);

export const parseImageUrlFromRedditCommentBody = (body: string) =>
  safelyParseWrappedText(body, URL_WRAPPER_EXPRESSION);

export const isImgurAlbumUrl = (url: string) => url.includes(IMGUR_ALBUM_URL);

export type DirectLink = "direct-link";
export type ImgurAlbum = "imgur-album";
export type ImgurGallery = "imgur-gallery";
export type ImgurDirect = "imgur-direct";
export type SubmissionUrlType =
  | DirectLink
  | ImgurAlbum
  | ImgurGallery
  | ImgurDirect
  | null;

export const checkForValidImageExtension = (extension: string) =>
  [
    "jpg",
    "jpeg",
    "jpe",
    "jif",
    "jfif",
    "jfi",
    "png",
    "gif",
    "webp",
    "svg",
  ].includes(extension);

export const generateUrlType = (
  title: string,
  imageUrl: string
): SubmissionUrlType => {
  if (imageUrl === null || title === "deleted") return null;

  const urlEndpoint = imageUrl.split("/").pop();
  if (!urlEndpoint) return null;

  const extension = urlEndpoint.split(".").pop();
  if (!extension) return null;

  if (
    checkForValidImageExtension(extension) ||
    imageUrl.includes("i.imgur.com")
  )
    return "direct-link";
  if (imageUrl.includes("imgur.com/gallery/")) return "imgur-gallery";
  if (imageUrl.includes("imgur.com/a/")) return "imgur-album";
  if (imageUrl.includes("imgur.com/")) return "imgur-direct";

  return null;
};

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}

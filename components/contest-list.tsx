"use client";

import { useQuery } from "@tanstack/react-query";
import Link from "next/link";
import { fetchRedditPosts } from "../lib/api-clients/reddit";
import { PiRedditLogo } from "react-icons/pi";
import { FaRegCommentDots, FaRegThumbsUp } from "react-icons/fa";
import { Skeleton } from "@/components/ui/skeleton";

const SkeletonContestLoading = () => (
  <div className="flex flex-col space-y-3">
    <Skeleton className="w-full h-48 rounded-xl" />
    <div className="space-y-2 flex flex-col justify-center items-center">
      <Skeleton className="h-4 w-[250px]" />
      <Skeleton className="h-4 w-[200px]" />
    </div>
  </div>
);

const ContestList = () => {
  const { data } = useQuery({
    queryKey: ["contests"],
    queryFn: async () => await fetchRedditPosts(),
  });

  if (!data) {
    return (
      <div className="grid grid-cols-2 lg:grid-cols-3 gap-6">
        {Array.from({ length: 9 }).map((_, index) => (
          <div key={index}>
            <SkeletonContestLoading />
          </div>
        ))}
      </div>
    );
  }

  return (
    <div className="grid grid-cols-2 lg:grid-cols-3 gap-6">
      {data.map((contest: any) => (
        <div key={contest.id}>
          <div
            key={contest.id}
            className="bg-white rounded-lg shadow-md overflow-hidden"
          >
            <Link href={`/contests/${contest.id}`} className="block">
              <img
                src={contest.imageUrl}
                alt={contest.title}
                className="w-full h-48 object-cover"
              />
            </Link>
          </div>
          <div className="p-2 text-center">
            <h2 className="text-md font-semibold mb-1">
              {contest.title.replace("PsBattle: ", "")}
            </h2>

            <ul className="flex space-x-2 justify-center text-">
              <li className="flex items-center mb-2  px-3 py-1">
                <FaRegCommentDots className="inline mr-2" />
                <span className="text-gray-600">{contest.commentCount}</span>
              </li>
              <li className="flex items-center mb-2  px-3 py-1">
                <FaRegThumbsUp className="inline mr-2" />
                <span className="text-gray-600">{contest.upVoteCount}</span>
              </li>
              <li className="flex items-center mb-2  px-3 py-1">
                <PiRedditLogo className="inline mr-2" />
                <a
                  href={contest.permanentLink}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="text-blue-500 hover:underline"
                >
                  <span className="text-gray-600">Reddit</span>
                </a>
              </li>
            </ul>
          </div>
        </div>
      ))}
    </div>
  );
};

export default ContestList;

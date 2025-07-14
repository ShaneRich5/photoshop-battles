"use client";

import { useQuery } from "@tanstack/react-query";
import Link from "next/link";

const ContestList = () => {
  const { data } = useQuery({
    queryKey: ["contests"],
    queryFn: async () => {
      const response = await fetch("/api/contests");
      const data = await response.json();
      return data.data; // Assuming the API returns an object with a 'data' property containing the contests
    },
  });

  if (!data) {
    return <p>Loading contests...</p>;
  }
  return (
    <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
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
          <div className="p-2">
            <h2 className="text-md font-semibold mb-2">
              {contest.title.replace("PsBattle: ", "")}
            </h2>

            {/* <ul className="flex space-x-2">
              <li className="flex items-center mb-2 border-2 border-gray-300 rounded-full px-3 py-1">
                <FaRegCommentDots className="inline mr-2" />
                <span className="text-gray-600">{contest.commentCount}</span>
              </li>
              <li className="flex items-center mb-2 border-2 border-gray-300 rounded-full px-3 py-1">
                <FaRegThumbsUp className="inline mr-2" />
                <span className="text-gray-600">{contest.upVoteCount}</span>
              </li>
              <li className="flex items-center mb-2 border-2 border-gray-300 rounded-full px-3 py-1">
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
            </ul> */}
          </div>
        </div>
      ))}
    </div>
  );
};

export default ContestList;

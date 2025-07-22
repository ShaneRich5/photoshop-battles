"use client";

import { useQuery } from "@tanstack/react-query";
import { fetchRedditPostById } from "../lib/api-clients/reddit";

interface ContestHeaderSummaryProps {
  contestId: string;
}

const ContestHeaderSummary = ({ contestId }: ContestHeaderSummaryProps) => {
  const { isLoading, data: contest } = useQuery({
    queryKey: ["contests", { contestId }],
    queryFn: async () => await fetchRedditPostById(contestId),
    refetchOnWindowFocus: false,
    retry: 0,
  });

  if (isLoading) {
    return <div>Loading...</div>;
  }

  if (!contest) {
    return <div>Contest not found</div>;
  }

  return (
    <div className="flex flex-col items-center">
      <img
        src={contest.imageUrl}
        alt={contest.title}
        className="h-96 mb-4 object-cover rounded-lg"
      />
      <h2 className="text-xl font-bold mb-0">{contest.title}</h2>
      <p className="text-gray-600 mb-8">by {contest.author || "Unknown"}</p>
    </div>
  );
};

export default ContestHeaderSummary;

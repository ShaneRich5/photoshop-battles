"use client";

import Link from "next/link";
import { MdArrowBack } from "react-icons/md";
import { useQuery } from "@tanstack/react-query";
import { fetchRedditPostById } from "@/lib/api-clients/reddit";

interface ContestDetailProps {
  contestId: string;
}

const ContestDetail = ({ contestId }: ContestDetailProps) => {
  const { isLoading, data } = useQuery({
    queryKey: ["contests", contestId],
    queryFn: async () => await fetchRedditPostById(contestId),
  });

  if (isLoading) {
    return <div>Loading...</div>;
  }

  if (!data) {
    return <div>Contest not found</div>;
  }

  const { contest, submissions } = data;

  return (
    <main className="max-w-6xl mx-auto px-4 py-8">
      <div className="absolute top-0 left-0 p-4">
        <Link href="/" className="flex items-center mb-6">
          <MdArrowBack className="text-xl cursor-pointer" />
          <span className="text-gray-600 ml-2 text-lg font-bold">
            Back to Contests
          </span>
        </Link>
      </div>
      <div className="flex flex-col items-center">
        <img
          src={contest.imageUrl}
          alt={contest.title}
          className="h-96 mb-4 object-cover rounded-lg"
        />
        <h2 className="text-xl font-bold mb-0">{contest.title}</h2>
        <p className="text-gray-600 mb-8">by {contest.author || "Unknown"}</p>
      </div>
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
        {submissions
          .filter((submission) => submission.imageUrl)
          .map((submission: any) => (
            <div key={submission.id} className="text-center ">
              <img
                src={submission.imageUrl}
                alt={submission.title}
                className="w-full object-cover rounded-lg"
              />
              <h2 className="text-md font-semibold mt-2">{submission.title}</h2>
              <p className="text-gray-600 text-sm">by {submission.author}</p>
            </div>
          ))}
      </div>
    </main>
  );
};

export default ContestDetail;

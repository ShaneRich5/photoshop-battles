"use client";

import { useQuery } from "@tanstack/react-query";
import {
  fetchRedditPostById,
  fetchRedditSubmissionListByPostId,
} from "../lib/api-clients/reddit";
import {
  LoadedContestHeader,
  SkeletonContestHeader,
} from "./contest-header-summary";

interface ContestDetailProps {
  contestId: string;
}

const ContestDetail = ({ contestId }: ContestDetailProps) => {
  const { isLoading, data: contest } = useQuery({
    queryKey: ["contests", { contestId }],
    queryFn: async () => await fetchRedditPostById(contestId),
    refetchOnWindowFocus: false,
    retry: 0,
  });

  const { isLoading: isSubmissionListLoading, data: submissions } = useQuery({
    queryKey: ["contest-submissions", { contestId }],
    queryFn: async () => await fetchRedditSubmissionListByPostId(contestId),
    refetchOnWindowFocus: false,
    retry: 0,
  });

  const header = isLoading ? (
    <SkeletonContestHeader />
  ) : (
    <LoadedContestHeader contest={contest} />
  );
  return (
    <div>
      <div className="mb-8">{header}</div>
      {JSON.stringify(submissions, null, 2)}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
        {isSubmissionListLoading ?? "Loading submissions..."}
        {((submissions as any[]) || [])
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
    </div>
  );
};

export default ContestDetail;

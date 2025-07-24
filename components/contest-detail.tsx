"use client";

import { useQuery } from "@tanstack/react-query";
import { fetchRedditPostById } from "../lib/api-clients/reddit";
import {
  LoadedContestHeader,
  SkeletonContestHeader,
} from "./contest-header-summary";
import SubmissionItem from "./submission-image";

interface ContestDetailProps {
  contestId: string;
}

const ContestDetail = ({ contestId }: ContestDetailProps) => {
  const { isLoading, data: contestDetail } = useQuery({
    queryKey: ["contests", { contestId }],
    queryFn: async () => await fetchRedditPostById(contestId),
    refetchOnWindowFocus: false,
    retry: 0,
  });

  const { contest, submissions } = contestDetail || {};

  const header =
    isLoading || !contest ? (
      <SkeletonContestHeader />
    ) : (
      <LoadedContestHeader contest={contest} />
    );
  return (
    <div>
      <div className="mb-8">{header}</div>
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
        {((submissions as any[]) || [])
          .filter((submission) => submission.imageUrl)
          .map((submission: any) => (
            <SubmissionItem key={submission.id} submission={submission} />
          ))}
      </div>
      {/* Submissions:
      {JSON.stringify(submissions, null, 2)} */}
    </div>
  );
};

export default ContestDetail;

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
    </div>
  );
};

export default ContestDetail;

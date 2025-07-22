"use client";

import { useQuery } from "@tanstack/react-query";
import { fetchRedditPostById } from "../lib/api-clients/reddit";
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

  const header = isLoading ? (
    <SkeletonContestHeader />
  ) : (
    <LoadedContestHeader contest={contest} />
  );
  return (
    <div>
      <div className="mb-8">{header}</div>
    </div>
  );
};

export default ContestDetail;

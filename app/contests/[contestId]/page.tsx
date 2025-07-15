import ContestDetail from "@/components/contest-detail";

interface ContestDetailPageProps {
  params: Promise<{
    contestId: string;
  }>;
}

export default async function ContestDetailPage({
  params,
}: ContestDetailPageProps) {
  const { contestId } = await params;

  return (
    <div className="pt-4">
      <ContestDetail contestId={contestId} />
    </div>
  );
}

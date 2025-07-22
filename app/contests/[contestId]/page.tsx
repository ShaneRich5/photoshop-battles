import Link from "next/link";
import { MdArrowBack } from "react-icons/md";
import ContestDetail from "@/components/contest-detail";
import { fetchRedditSubmissionPostById } from "../../../lib/api-clients/reddit";
import ContestHeaderSummary from "../../../components/contest-header-summary";

interface ContestDetailPageProps {
  params: Promise<{
    contestId: string;
  }>;
}

export default async function ContestDetailPage({
  params,
}: ContestDetailPageProps) {
  const { contestId } = await params;
  const submissions = await fetchRedditSubmissionPostById(contestId);

  return (
    <div className="pt-4">
      <main className="max-w-6xl mx-auto px-4 py-8">
        <div className="absolute top-0 left-0 p-4">
          <Link href="/" className="flex items-center mb-6">
            <MdArrowBack className="text-xl cursor-pointer" />
            <span className="text-gray-600 ml-2 text-lg font-bold">
              Back to Contests
            </span>
          </Link>
        </div>
        <ContestHeaderSummary contestId={contestId} />
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
                <h2 className="text-md font-semibold mt-2">
                  {submission.title}
                </h2>
                <p className="text-gray-600 text-sm">by {submission.author}</p>
              </div>
            ))}
        </div>
      </main>
    </div>
  );
}

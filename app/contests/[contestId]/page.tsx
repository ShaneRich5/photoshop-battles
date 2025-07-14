import { fetchRedditPostById } from "@/lib/api-clients/reddit";

interface ContestDetailPageProps {
  params: Promise<{
    contestId: string;
  }>;
}

export default async function ContestDetailPage({
  params,
}: ContestDetailPageProps) {
  const { contestId } = await params;
  const { contest, submissions } = await fetchRedditPostById(contestId);

  return (
    <div className="pt-4">
      <main className="max-w-6xl mx-auto px-4 py-8">
        <div className="flex flex-col items-center">
          <img
            src={contest.imageUrl}
            alt={contest.title}
            className="h-96 mb-4 object-cover rounded-lg"
          />
          <h1 className="text-2xl font-bold mb-0">{contest.title}</h1>
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

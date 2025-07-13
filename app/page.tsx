import ContestList from "@/components/contest-list";

export default function Home() {
  return (
    <div className="pt-4">
      <main className="max-w-6xl mx-auto px-4 py-8">
        <h1 className="text-2xl font-bold mb-0">r/PhotoshopBattles</h1>
        <p className="text-gray-600 mb-8">
          A simple feed for people too lazy to open the individual links within
          the subreddit.
        </p>
        <ContestList />
      </main>
    </div>
  );
}

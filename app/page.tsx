import Image from "next/image";
import ContestList from "@/components/contest-list";

export default function Home() {
  return (
    <div className="pt-4">
      <main className="max-w-6xl mx-auto px-4 py-8">
        <h1>Contest List</h1>
        {/* Create a grid for the images in*/}
        <h1 className="text-2xl font-bold mb-4">Photoshop Battles</h1>
        <p className="text-gray-600 mb-8">
          A collection of the latest Photoshop Battles from Reddit.
        </p>
        <ContestList />
      </main>
    </div>
  );
}

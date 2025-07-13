import Image from "next/image";
import ContestList from "@/components/contest-list";

export default function Home() {
  return (
    <div className="pt-4">
      <main>
        <ContestList />
      </main>
    </div>
  );
}

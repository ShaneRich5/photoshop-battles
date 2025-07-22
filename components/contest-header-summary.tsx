"use client";

export const SkeletonContestHeader = () => (
  <div className="flex flex-col items-center space-y-4 w-3/4 mx-auto">
    <div className="w-full h-96 bg-gray-200 rounded-lg animate-pulse" />
    <div className="w-3/4 h-6 bg-gray-200 rounded animate-pulse" />
    <div className="w-1/2 h-4 bg-gray-200 rounded animate-pulse" />
  </div>
);

export const LoadedContestHeader = ({ contest }: { contest: any }) => (
  <div className="flex flex-col items-center">
    <img
      src={contest.imageUrl}
      alt={contest.title}
      className="h-96 mb-4 object-cover rounded-lg"
    />
    <h2 className="text-xl font-bold mb-0">{contest.title}</h2>
    <p className="text-gray-600">by {contest.author || "Unknown"}</p>
  </div>
);

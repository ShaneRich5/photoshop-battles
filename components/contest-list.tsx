"use client";

import { useQuery } from "@tanstack/react-query";

const ContestList = () => {
  const { data } = useQuery({
    queryKey: ["contests"],
    queryFn: async () => {
      const response = await fetch("/api/contests");
      const data = await response.json();
      return data.data; // Assuming the API returns an object with a 'data' property containing the contests
    },
  });
  return (
    <div className="max-w-6xl mx-auto px-4 py-8">
      <h1>Contest List</h1>
      {/* Create a grid for the images in*/}
      <h1 className="text-2xl font-bold mb-4">Photoshop Battles</h1>
      <p className="text-gray-600 mb-8">
        A collection of the latest Photoshop Battles from Reddit.
      </p>
      {/* Display the list of contests */}
      {/* If data is not available, show a loading message */}
      {!data ? (
        <p>Loading contests...</p>
      ) : (
        // If data is available, map through the contests and display them
        // Each contest will be displayed in a card-like format
        // with the title, image, upvote count, comment count, and a link to
        // the permanent link on Reddit
        // We will use Tailwind CSS for styling
        // We will use a responsive grid layout to display the contests
        // We will use a list to display the contests
        // We will use a flexbox to display the contests
        // We will use a card-like format to display the contests
        // We will use a grid layout to display the contests

        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
          {data.map((contest: any) => (
            <div
              key={contest.id}
              className="bg-white rounded-lg shadow-md overflow-hidden"
            >
              <img
                src={contest.imageUrl}
                alt={contest.title}
                className="w-full h-48 object-cover"
              />
              <div className="p-4">
                <h2 className="text-lg font-semibold mb-2">
                  {contest.title.replace("PsBattle: ", "")}
                </h2>
                <p className="text-gray-600">Upvotes: {contest.upVoteCount}</p>
                <p className="text-gray-600">
                  Comments: {contest.commentCount}
                </p>
                <a
                  href={contest.permanentLink}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="text-blue-500 hover:underline"
                >
                  View on Reddit
                </a>
              </div>
            </div>
          ))}
        </div>
      )}
      {/* If there are no contests, show a message */}
      {/* We will use a conditional rendering to show the message */}
    </div>
  );
};

export default ContestList;

"use client";

import { useQuery } from "@tanstack/react-query";

interface SubmissionItemProps {
  submission: any;
}

const SubmissionItem = ({ submission }: SubmissionItemProps) => {
  const { imageUrl } = submission;

  const { data: apiResponse } = useQuery({
    queryKey: ["submission-image", submission.id],
    queryFn: async () => {
      return fetch(
        `/api/generate-submission-image-url?imageUrl=${imageUrl}`
      ).then((res) => res.json());
    },
    refetchOnWindowFocus: false,
    retry: 0,
  });

  const processedImageUrl = apiResponse?.processedImageUrl || imageUrl;

  return (
    <div key={submission.id} className="text-center">
      <img
        src={processedImageUrl}
        alt={submission.title}
        className="w-full object-cover rounded-lg"
      />
      <h2 className="text-md font-semibold mt-2">{submission.title}</h2>
      <p className="text-gray-600 text-sm">by {submission.author}</p>
      <span className="hidden">Processed Image URL: {processedImageUrl}</span>
    </div>
  );
};

export default SubmissionItem;

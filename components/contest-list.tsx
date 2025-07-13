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
    <div>
      <h1>Contest List</h1>
      {/* Add your contest list rendering logic here */}
      <code>{JSON.stringify(data, null, 2)}</code>
      {data && data.length > 0 ? (
        <ul>
          {data.map((contest: any) => (
            <li key={contest.id}>
              <h2>{contest.title}</h2>
              <img src={contest.imageUrl} alt={contest.title} />
              <p>Upvotes: {contest.upVoteCount}</p>
              <p>Comments: {contest.commentCount}</p>
              <a
                href={contest.permanentLink}
                target="_blank"
                rel="noopener noreferrer"
              >
                View on Reddit
              </a>
            </li>
          ))}
        </ul>
      ) : (
        <p>No contests found.</p>
      )}
    </div>
  );
};

export default ContestList;

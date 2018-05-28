from mrjob.job import MRJob
from mrjob.step import MRStep
from heapq import nlargest, heappush, heappop

class MRWordFrequencyCount(MRJob):

	def steps(self):
		return [MRStep(mapper=self.mapper,combiner=self.combiner, reducer=self.reducer_counts_words),MRStep(reducer=self.reducer)]

	def mapper(self, _, line):
		words = line.split(",")
		if len(words) == 28:
			w = words[19].strip() + " , " + words[20].strip()
			yield w.lower(), 1

	def combiner(self, word, counts):
		yield (word, sum(counts))

	def reducer_counts_words(self, word, counts):
		yield None, (sum(counts), word)

	def reducer(self, _ , word_count_pairs):
		names = []
		for count, name in word_count_pairs:
			heappush(names, (count ,name))
		print("10 most frequently visited staff members : ")
		print(nlargest(10, names))


if __name__ == '__main__':
	MRWordFrequencyCount.run()

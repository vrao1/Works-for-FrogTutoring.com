from mrjob.job import MRJob
from mrjob.step import MRStep
from heapq import nlargest, heappush, heappop

class MRWordFrequencyCount(MRJob):

	def steps(self):
		return [MRStep(mapper=self.mapper,combiner=self.combiner, reducer=self.reducer_counts_words),MRStep(reducer=self.reducer)]

	def mapper(self, _, line):
		words = line.split(",")
		if len(words) == 28:
			w = words[0].strip() + " , " + words[1].strip() + "_" + words[19].strip() + " , " + words[20].strip()
			yield w.lower(), 1

	def combiner(self, word, counts):
		yield (word, sum(counts))

	def reducer_counts_words(self, word, counts):
		yield None, (sum(counts), word)

	def reducer(self, _ , word_count_pairs):

		guests = dict()
		visitees = dict()

		for count, name in word_count_pairs:
			people = name.split("_")
			if len(people) == 2:
				if people[0]:
					guests[people[0]] = 1
				if people[1]:
					visitees[people[1]] = 1

		print("People who were visitor and member in 2009 and 2010")
		for key in visitees.keys():
			if key in guests.keys():
				print(key)


if __name__ == '__main__':
	MRWordFrequencyCount.run()

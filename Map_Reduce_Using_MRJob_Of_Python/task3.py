from mrjob.job import MRJob
from mrjob.step import MRStep
from heapq import nlargest, heappush, heappop

class MRWordFrequencyCount(MRJob):

	def steps(self):
		return [MRStep(mapper=self.mapper,combiner=self.combiner, reducer=self.reducer_counts_words),MRStep(reducer=self.reducer)]

	def mapper(self, _, line):
		words = line.split(",")
		if len(words) == 28:
			toa = words[6].strip() # Time of Arrival e.g., 01/01/2009 12:00:03
			date = toa.split(" ")  # 01/01/2009
			year = date[0].split("/") # array of 01, 01, 2009
			if (len(year) == 3 and (year[2] == "2009" or year[2] == "2010")):
				w = year[2] + "_" + words[0].strip() + " , " + words[1].strip()
				yield w.lower(), 1

	def combiner(self, word, counts):
		yield (word, sum(counts))

	def reducer_counts_words(self, word, counts):
		yield None, (sum(counts), word)

	def reducer(self, _ , word_count_pairs):

		visitors_2009 = dict()
		visitors_2010 = dict()

		for count, name in word_count_pairs:
			visitors = name.split("_")
			if len(visitors) == 2:
				if visitors[0] == "2009":
					visitors_2009[visitors[1]] = count
				else:
					visitors_2010[visitors[1]] = count
		print("Visitors who visited in 2009 and 2010 at least once")
		for key in visitors_2009.keys():
			if key in visitors_2010.keys():
				print(key)


if __name__ == '__main__':
	MRWordFrequencyCount.run()

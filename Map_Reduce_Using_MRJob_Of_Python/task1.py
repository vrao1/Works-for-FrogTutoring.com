from mrjob.job import MRJob
from mrjob.step import MRStep
import re

class MRWordFrequencyCount(MRJob):

	def steps(self):
		return [MRStep(mapper=self.mapper_get_words,reducer=self.reducer_count_words),MRStep(mapper=self.mapper_make_counts_key,reducer=self.reducer_output_words)]

	def mapper_get_words(self, _, line):
		words = line.split(",")
		if len(words) == 28:
			w = words[0].strip() + " , " + words[1].strip()
			yield w.lower(), 1

	def reducer_count_words(self, word, values):
		yield word, sum(values)

	def mapper_make_counts_key(self, word, count):
        # sort by values
		if int(count) >= 10:
			yield '%04d' % int(count), word

	def reducer_output_words(self, count, words):
		for word in words:
			yield count, word


if __name__ == '__main__':
	MRWordFrequencyCount.run()

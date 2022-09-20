let points = {
  total: [0, 1],
};

const judge = (outputFile) => {
  const score_line_idx = outputFile.indexOf("Test passed");
  if (score_line_idx == -1) {
    return points;
  }
  const score_line = outputFile.substring(score_line_idx);
  const score_regex = /(\d+)\/(\d+)/;
  const score = score_line.match(score_regex);
  points.total = [score[1], score[2]];
  return points;
};

module.exports.judge = judge;

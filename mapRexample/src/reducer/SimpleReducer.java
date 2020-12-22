package reducer;

import org.apache.hadoop.io.FloatWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;
import java.io.IOException;

public class SimpleReducer extends Reducer<Text, FloatWritable, Text, FloatWritable> {
    private FloatWritable result = new FloatWritable();

    public void reduce(Text key, Iterable<FloatWritable> values, Context context ) throws IOException, InterruptedException {
      float sum = 0.0f;
      
      for (FloatWritable monto : values) 
      {
        sum += monto.get();
      }
      
      result.set(sum);
      context.write(key, result);
    }
}
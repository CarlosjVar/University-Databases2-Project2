package main;


import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.FloatWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

import maper.SimpleMaper;
import reducer.SimpleReducer;

public class program {

	public static void main(String[] args) throws Exception {
		Configuration conf = new Configuration();
	    Job job = Job.getInstance(conf, "Job de prueba");
	    job.setJarByClass(program.class);
	    job.setMapperClass(SimpleMaper.class);
	    job.setReducerClass(SimpleReducer.class);
	    job.setOutputKeyClass(Text.class);
	    job.setOutputValueClass(FloatWritable.class);
	    FileInputFormat.addInputPath(job, new Path(args[1]));
	    FileOutputFormat.setOutputPath(job, new Path(args[2]));
	    System.exit(job.waitForCompletion(true) ? 0 : 1);
	}
}

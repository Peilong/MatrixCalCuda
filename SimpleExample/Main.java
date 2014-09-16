import java.util.Scanner;
import java.io.File;
/**
 *
 * @author Adel Ahmed
 */
public class Main
{
    public static int SIZE = 10;

    static
    {
	Scanner input = new Scanner(System.in);
	System.out.println("Enter library name: ");
	String libName = input.nextLine();
	try
	{
	   File path = new File("");
	   System.out.println("Current Path = " + path.getAbsolutePath());
	   String libPath = path.getAbsolutePath() + File.separator + libName;
	   System.out.println("Trying to load library [" + libPath + "] ...");
	   System.load(libPath);
	   System.out.println("Library loaded");
	}
	catch (Exception e)
	{
	   System.out.println("Error: " + e);
	}
    }

    public native int CUDAProxy_matrixAdd(float[] a, float[] b, float[] c);	

    public static void main(String[] args)
    {
        System.out.println("Hello CUDA through JNI!");
	// make an instance of our class to access the native method
        Main m = new Main();
	// declare three arras
        float[] a = new float[SIZE];
        float[] b = new float[SIZE];
        float[] c = new float[SIZE];
	// initialize two arrays
        for (int i = 0; i < a.length; i++)
            a[i] = b[i] = i;
        System.out.println("J: Arrays initialized, calling C.");
	// call the native method, which in turn will execute kernel code on the device
        int retVal = m.CUDAProxy_matrixAdd(a, b, c);
        System.out.println("J: retVal = \nJ:c[]= " + retVal);
	// print the results
        for (int i = 0; i < retVal; i++)
            System.out.print(c[i] + "| ");
        System.out.println();
    }
}

import java.nio.file.Files;
import java.nio.file.Paths;
import javax.swing.JOptionPane;
import java.time.LocalTime;

public class skt 
{
	static LocalTime today;
	static String productsString;
	public static void main(String[] args) throws Exception 
	{	
		String selectionInput=null;
		int selectionInputINT=0;
		do
		{	
			String Menu="";
			for(mainMenu option: mainMenu.values())
			{	
				Menu+=option.getNum();
				Menu+=option.getDesc();
			}
			
			selectionInput=JOptionPane.showInputDialog(null, Menu, "Welcome to Son Kullanma Tarifi", JOptionPane.PLAIN_MESSAGE);			
			selectionInputINT=Integer.parseInt(selectionInput);
			
			if(selectionInputINT==1) //register
			{
				new products();
				
			}
			else if(selectionInputINT==2) //only login
			{
				new search();
			}
		}while(selectionInputINT!=0);
  	}
	public static String readJson(String fileName) throws Exception
	{
		String json = new String(Files.readAllBytes(Paths.get(fileName)));
	    return json;
	}
	public static void updateData() throws Exception
	{
		today = LocalTime.now();
		productsString = readJson("database");
	}
}

import javax.swing.JOptionPane;

public class search
{
	public search() throws Exception
	{
		String selectionInput=null;
		
		do
		{	
			selectionInput=JOptionPane.showInputDialog(null, "", "Search For Recipe (0 to go back)", JOptionPane.PLAIN_MESSAGE);
			if(!selectionInput.equals("0"))
			{
				System.out.print(selectionInput+"\n");
				//google search
			}
			else break;
			
		}while(true);
	}
}

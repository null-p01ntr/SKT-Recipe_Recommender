
public enum productsMenu
{
	one("(1)", "Add\n"), 
	two("(2)", "Set Reminder\n"),
	zero("(0)", "Exit\n");
	
	private final String num;
	private final String desc;
	
	productsMenu(String number, String description)
	{
		num=number;
		desc=description;
	}
	
	public String getNum()
	{
		return num;
	}
	
	public String getDesc()
	{
		return desc;
	}
}

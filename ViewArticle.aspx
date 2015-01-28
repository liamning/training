Enter file contents hereusing System;
using System.Collections.Generic; 
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class ViewArticle : System.Web.UI.Page
{
    public System.Text.StringBuilder imageContent = new System.Text.StringBuilder();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString["ID"] == null) return;

        int ID = Convert.ToInt32(Request.QueryString["ID"]);
        News article = new News();
        NewsInfo articleInfo = article.getArticle(ID);

        labHeadline.InnerText = articleInfo.Headline;
        labSummary.InnerText = articleInfo.Summary;
        labContent.InnerHtml = articleInfo.Content;
          
        //show the image in the gallery
        List<ImageInfo> articleImages = articleInfo.getImageList();
        if(articleImages.Count >= 3)
			imgSummary.ImageUrl = "Service/ImageHandler.ashx?ID=" + articleImages[2].ID.ToString();
 
        ImageInfo imageinfo;
        string desc;
        for (int i = 3; i < articleImages.Count; i++)
        {
            imageinfo = articleImages[i]; 
            desc = imageinfo.Description.Replace("Add Description","").Trim();

            imageContent.Append("<div><a href='Service/ImageHandler.ashx?ID=");
            imageContent.Append(imageinfo.ID.ToString());
            imageContent.Append("' title='");
            imageContent.Append(desc);
            imageContent.Append("'><img src='Service/PreviewImageHandler.ashx?maxLength=199&limitWidth=1&ID=");
            imageContent.Append(imageinfo.ID.ToString());
            imageContent.Append("'");
            imageContent.Append(" /></a>");
            imageContent.Append(desc == "" ? "" : "<p>"+desc+"</p>");
            imageContent.Append("</div>");
             
        }

        //show the attachment in the news details page
        List<FileInfo> articleAttachment = articleInfo.getFileList();
        System.Text.StringBuilder attachmentContent = new System.Text.StringBuilder();

        FileInfo fileInfo;

        for (int i = 0; i < articleAttachment.Count; i++)
        {
            if (i == 0)
            {
                attachmentContent.Append("<br/><p><u><b>Attachment: </b></u></p>");
            }
            fileInfo = articleAttachment[i];
            attachmentContent.Append("<a href='Service/FileService.aspx?ID=");
            attachmentContent.Append(fileInfo.ID);
            attachmentContent.Append("'>");
            attachmentContent.Append(fileInfo.Description);
            attachmentContent.Append("</a><br/>");
        }
        labAttachment.InnerHtml = attachmentContent.ToString();

        File file = new File(); 
        System.Text.StringBuilder newsLetters = file.getQuickLinkList(2);
        divNewsLetters.InnerHtml = newsLetters.ToString();



        this.ControlDataBind();
                
    }


    protected void ControlDataBind()
    {
        System.Data.DataTable EventType = SystemPara.getSystemPara("SuggestionType");

        foreach (System.Data.DataRow row in EventType.Rows)
        {
            this.comSuggestionType.Items.Add(new ListItem(row["Description"].ToString(), row["ID"].ToString()));
        }

    }

}

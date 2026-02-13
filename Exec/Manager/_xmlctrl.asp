<%
  function NewXMLObj(XMLText, DTDvalid)
  {
    var xmlDoc = Server.CreateObject("Msxml2.DOMDocument");
    
    xmlDoc.async = false;
    xmlDoc.resolveExternals = false;
    
    if (DTDvalid == null || !DTDvalid)
      xmlDoc.validateOnParse = false;
    else
      xmlDoc.validateOnParse = true;
    
    xmlDoc.loadXML(XMLText);
    
    if (xmlDoc.parseError != 0)
      SystemErrorMsg('XML Parsing ¿ù»~\nline:' + xmlDoc.parseError.line + ' pos:' + xmlDoc.parseError.linepos + '\n' + xmlDoc.parseError.reason);
    
    return xmlDoc;
  }
  
  function NewXMLObjFromFile(XMLFileName, DTDvalid)
  {
    var xmlDoc = Server.CreateObject("Msxml2.DOMDocument");
    
    xmlDoc.async = false;
    xmlDoc.resolveExternals = false;

    if (DTDvalid == null || !DTDvalid)
      xmlDoc.validateOnParse = false;
    else
      xmlDoc.validateOnParse = true;
    
    xmlDoc.load(XMLFileName);
    
    if (xmlDoc.parseError != 0)
      SystemErrorMsg('XML Parsing ¿ù»~\nline:' + xmlDoc.parseError.line + ' pos:' + xmlDoc.parseError.linepos + '\n' + xmlDoc.parseError.reason);
    
    return xmlDoc;
  }
  
  function XMLBrowse(XmlObj)
  {
    function WriteNodes(Node)
    {
      Response.Write('<li type="square"><font color=blue>&lt;' + Node.tagName + '</font>');
      if (Node.attributes != null)
        for (var i=0; i<Node.attributes.length; i++)
          Response.Write(' <font color=#000080>' + Node.attributes.item(i).name + '=' + Node.attributes.item(i).value + '</font>');
      Response.Write('<font color=blue>&gt;</font></li>\n');
      
      if (Node.childNodes.length > 1)
      {
        Response.Write('<ul>\n');
        for (var i=0; i<Node.childNodes.length; i++)
          WriteNodes(Node.childNodes.item(i));
        Response.Write('</ul>\n');
      }
      else if (Node.childNodes.length > 0 && Node.text != null)
        Response.Write('<font color=red>' + Node.text + '</font>\n');
    }
    
    WriteNodes(XmlObj.documentElement);
  }
%>

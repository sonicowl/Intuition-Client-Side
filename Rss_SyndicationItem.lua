SyndicationItem = class("SyndicationItem")

require "sqlite3"

SyndicationItem.id = nil;
SyndicationItem.question = '';
SyndicationItem.totalViews = '';
SyndicationItem.answer1 = '';
SyndicationItem.answer2 = '';
SyndicationItem.answer3 = '';
SyndicationItem.answer4 = '';
SyndicationItem.answer5 = '';
SyndicationItem.answer6 = '';
SyndicationItem.qtanswer1 = '';
SyndicationItem.qtanswer2 = '';
SyndicationItem.qtanswer3 = '';
SyndicationItem.qtanswer4 = '';
SyndicationItem.qtanswer5 = '';
SyndicationItem.qtanswer6 = '';
SyndicationItem.selectedAnswer = '';

function SyndicationItem:initialize(obj)
	
	--Open data.db.  If the file doesn't exist it will be created
	local path = system.pathForFile("data.db", system.DocumentsDirectory)
	db = sqlite3.open( path )
	
	self.question = obj.question;
	self.totalViews = obj.totalViews;
	self.answer1 = obj.answer1;
	self.answer2 = obj.answer2;
	self.answer3 = obj.answer3;
	self.answer4 = obj.answer4;
	self.answer5 = obj.answer5;
	self.answer6 = obj.answer6;
	self.qtanswer1 = obj.qtanswer1;
	self.qtanswer2 = obj.qtanswer2;
	self.qtanswer3 = obj.qtanswer3;
	self.qtanswer4 = obj.qtanswer4;
	self.qtanswer5 = obj.qtanswer5;
	self.qtanswer6 = obj.qtanswer6;	
	self.completed = 0;	
	
	--[[ self.title = XmlParser:XmlValue(node, "title")
	self.link = XmlParser:XmlValue(node, "link")
	self.description = XmlParser:XmlValue(node, "description")
	self.updatedDate = XmlParser:XmlValue(node, "a10:updated")
	
	local enclosure = XmlParser:XmlAttributes(node, "enclosure")
	if enclosure then self.enclosureUrl = enclosure.url end
	--]]
	
	local tablesetup = [[CREATE TABLE IF NOT EXISTS questions (id INTEGER PRIMARY KEY, question, totalViews, answer1, answer2, answer3, answer4, answer5, answer6, qtanswer1, qtanswer2, qtanswer3, qtanswer4, qtanswer5, qtanswer6, completed, selectedAnswer);]]
	print(tablesetup)
	db:exec( tablesetup )
	local tablefill =[[INSERT INTO test VALUES (NULL, ']]..self.question..[[',']]..self.totalViews..[[',']]..self.answer1..[[',']]..self.answer2..[[',']]..self.answer3..[[',']]..self.answer4..[[',']]..self.answer5..[[',']]..self.answer6..[[',']]..self.qtanswer1..[[',']]..self.qtanswer2..[[',']]..self.qtanswer3..[[',']]..self.qtanswer4..[[',']]..self.qtanswer5..[[',']]..self.qtanswer6..[[',']]..self.completed..[[',']]..self.selectedAnswer..[['); ]]
	db:exec( tablefill )
	
end

--Handle the applicationExit event to close the db
local function onSystemEvent( event )
        if( event.type == "applicationExit" ) then              
            db:close()
        end
end

Runtime:addEventListener( "system", onSystemEvent )
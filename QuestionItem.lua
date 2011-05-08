QuestionItem = class("QuestionItem")

require "sqlite3"

QuestionItem.id = nil;
QuestionItem.question = '';
QuestionItem.totalViews = '';
QuestionItem.answer1 = '';
QuestionItem.answer2 = '';
QuestionItem.answer3 = '';
QuestionItem.answer4 = '';
QuestionItem.answer5 = '';
QuestionItem.answer6 = '';
QuestionItem.qtanswer1 = '';
QuestionItem.qtanswer2 = '';
QuestionItem.qtanswer3 = '';
QuestionItem.qtanswer4 = '';
QuestionItem.qtanswer5 = '';
QuestionItem.qtanswer6 = '';
QuestionItem.selectedAnswer = '';

function QuestionItem:initialize(obj)
	
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
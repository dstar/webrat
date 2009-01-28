require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe "check" do
  it "should fail if no checkbox found" do
    with_html <<-HTML
      <html>
        <form method="post" action="/login">
        </form>
      </html>
    HTML

    lambda { check "remember_me" }.should raise_error(Webrat::NotFoundError)
  end

  it "should fail if input is not a checkbox" do
    with_html <<-HTML
      <html>
        <form method="post" action="/login">
          <input type="text" name="remember_me" />
        </form>
      </html>
    HTML

    lambda { check "remember_me" }.should raise_error(Webrat::NotFoundError)
  end

  it "should check rails style checkboxes" do
    with_html <<-HTML
      <html>
      <form method="get" action="/login">
        <input id="user_tos" name="user[tos]" type="checkbox" value="1" />
        <input name="user[tos]" type="hidden" value="0" />
        <label for="user_tos">TOS</label>
        <input type="submit" />
      </form>
      </html>
    HTML

    webrat_session.should_receive(:get).with("http://www.example.com/login", "user" => {"tos" => "1"})
    check "TOS"
    click_button
  end

  it "should result in the value on being posted if not specified" do
    with_html <<-HTML
      <html>
        <form method="post" action="/login">
          <input type="checkbox" name="remember_me" />
          <input type="submit" />
        </form>
      </html>
    HTML

    webrat_session.should_receive(:post).with("http://www.example.com/login", "remember_me" => "on")
    check "remember_me"
    click_button
  end

  it "should fail if the checkbox is disabled" do
    with_html <<-HTML
      <html>
        <form method="post" action="/login">
          <input type="checkbox" name="remember_me" disabled="disabled" />
          <input type="submit" />
        </form>
      </html>
    HTML

    lambda { check "remember_me" }.should raise_error(Webrat::DisabledFieldError)
  end

  it "should result in a custom value being posted" do
    with_html <<-HTML
      <html>
        <form method="post" action="/login">
          <input type="checkbox" name="remember_me" value="yes" />
          <input type="submit" />
        </form>
      </html>
    HTML

    webrat_session.should_receive(:post).with("http://www.example.com/login", "remember_me" => "yes")
    check "remember_me"
    click_button
  end
end

describe "uncheck" do
  it "should fail if no checkbox found" do
    with_html <<-HTML
      <html>
      <form method="post" action="/login">
      </form>
      </html>
    HTML

    lambda { uncheck "remember_me" }.should raise_error(Webrat::NotFoundError)
  end

  it "should fail if input is not a checkbox" do
    with_html <<-HTML
      <html>
      <form method="post" action="/login">
        <input type="text" name="remember_me" />
      </form>
      </html>
    HTML

    lambda { uncheck "remember_me" }.should raise_error(Webrat::NotFoundError)
  end

  it "should fail if the checkbox is disabled" do
    with_html <<-HTML
      <html>
      <form method="post" action="/login">
        <input type="checkbox" name="remember_me" checked="checked" disabled="disabled" />
        <input type="submit" />
      </form>
      </html>
    HTML
    lambda { uncheck "remember_me" }.should raise_error(Webrat::DisabledFieldError)
  end

  it "should uncheck rails style checkboxes" do
    with_html <<-HTML
      <html>
      <form method="get" action="/login">
        <input id="user_tos" name="user[tos]" type="checkbox" value="1" checked="checked" />
        <input name="user[tos]" type="hidden" value="0" />
        <label for="user_tos">TOS</label>
        <input type="submit" />
      </form>
      </html>
    HTML
    webrat_session.should_receive(:get).with("http://www.example.com/login", "user" => {"tos" => "0"})
    check "TOS"
    uncheck "TOS"
    click_button
  end

  it "should result in value not being posted" do
    with_html <<-HTML
      <html>
      <form method="post" action="/login">
        <input type="checkbox" name="remember_me" value="yes" checked="checked" />
        <input type="submit" />
      </form>
      </html>
    HTML
    webrat_session.should_receive(:post).with("http://www.example.com/login", {})
    uncheck "remember_me"
    click_button
  end
end

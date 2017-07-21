defmodule ConduitWeb.CommentControllerTest do
  use ConduitWeb.ConnCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "comment on article" do
    setup [
      :register_user,
      :get_author,
      :publish_article,
    ]

    @tag :web
    test "should create and return comment when data is valid", %{conn: conn, user: user} do
      conn = post authenticated_conn(conn, user), comment_path(conn, :create, "how-to-train-your-dragon"), comment: build(:comment)
      json = json_response(conn, 201)["comment"]
      id = json["id"]
      created_at = json["createdAt"]
      updated_at = json["updatedAt"]

      refute id == ""
      refute created_at == ""
      refute updated_at == ""

      assert json == %{
        "id" => id,
        "createdAt" => created_at,
        "updatedAt" => updated_at,
        "body" => "It takes a Jacobian",
        "author" => %{
          "username" => "jake",
          "bio" => nil,
          "image" => nil,
          "following" => false,
        }
      }
    end
  end
end
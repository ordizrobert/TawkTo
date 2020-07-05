//
//  UsersModel.swift
//  TawkTo
//
//  Created by robert ordiz on 7/5/20.
//  Copyright © 2020 robert ordiz. All rights reserved.
//

import Foundation

struct UsersModel {
    let login: String?
    let node_id: String?
    let avatar_url: String?
    let gravatar_id: String?
    let url: String?
    let html_url: String?
    let followers_url: String?
    let following_url: String?
    let gists_url: String?
    let starred_url: String?
    let subscriptions_url: String?
    let organizations_url: String?
    let repos_url: String?
    let events_url: String?
    let received_events_url: String?
    let type: String?
    let site_admin: Bool?
    let id: Int?
    let name: String?
    let company: String?
    let blog: String?
    let followers: Int?
    let following: Int?
}

extension UsersModel: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: UsersModelCodingKeys.self)
        try container.encode(login, forKey: .login)
        try container.encode(node_id, forKey: .node_id)
        try container.encode(avatar_url, forKey: .avatar_url)
        try container.encode(gravatar_id, forKey: .gravatar_id)
        try container.encode(url, forKey: .url)
        try container.encode(html_url, forKey: .html_url)
        try container.encode(followers_url, forKey: .followers_url)
        try container.encode(following_url, forKey: .following_url)
        try container.encode(gists_url, forKey: .gists_url)
        try container.encode(starred_url, forKey: .starred_url)
        try container.encode(subscriptions_url, forKey: .subscriptions_url)
        try container.encode(organizations_url, forKey: .organizations_url)
        try container.encode(repos_url, forKey: .repos_url)
        try container.encode(events_url, forKey: .events_url)
        try container.encode(received_events_url, forKey: .received_events_url)
        try container.encode(type, forKey: .type)
        try container.encode(site_admin, forKey: .site_admin)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(company, forKey: .company)
        try container.encode(blog, forKey: .blog)
        try container.encode(followers, forKey: .followers)
        try container.encode(following, forKey: .following)
    }
}

extension UsersModel: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UsersModelCodingKeys.self)
        login = try container.decodeIfPresent(String.self, forKey: .login) ?? nil
        node_id = try container.decodeIfPresent(String.self, forKey: .node_id) ?? nil
        avatar_url = try container.decodeIfPresent(String.self, forKey: .avatar_url) ?? nil
        gravatar_id = try container.decodeIfPresent(String.self, forKey: .gravatar_id) ?? nil
        url = try container.decodeIfPresent(String.self, forKey: .url) ?? nil
        html_url = try container.decodeIfPresent(String.self, forKey: .html_url) ?? nil
        followers_url = try container.decodeIfPresent(String.self, forKey: .followers_url) ?? nil
        following_url = try container.decodeIfPresent(String.self, forKey: .following_url) ?? nil
        gists_url = try container.decodeIfPresent(String.self, forKey: .gists_url) ?? nil
        starred_url = try container.decodeIfPresent(String.self, forKey: .starred_url) ?? nil
        subscriptions_url = try container.decodeIfPresent(String.self, forKey: .subscriptions_url) ?? nil
        organizations_url = try container.decodeIfPresent(String.self, forKey: .organizations_url) ?? nil
        repos_url = try container.decodeIfPresent(String.self, forKey: .repos_url) ?? nil
        events_url = try container.decodeIfPresent(String.self, forKey: .events_url) ?? nil
        received_events_url = try container.decodeIfPresent(String.self, forKey: .received_events_url) ?? nil
        type = try container.decodeIfPresent(String.self, forKey: .type) ?? nil
        site_admin = try container.decodeIfPresent(Bool.self, forKey: .site_admin) ?? false
        id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? nil
        company = try container.decodeIfPresent(String.self, forKey: .company) ?? nil
        blog = try container.decodeIfPresent(String.self, forKey: .blog) ?? nil
        followers = try container.decodeIfPresent(Int.self, forKey: .followers) ?? 0
        following = try container.decodeIfPresent(Int.self, forKey: .following) ?? 0
    }
}


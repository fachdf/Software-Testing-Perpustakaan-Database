select 
  -- member information
  s.nim, 
  (select u.name
    from tb_m_user u
    where u.user_email = s.user_email) AS member_name,

  -- Book information
  b.book_cd,
  b.title,

  -- Loan Information
  DATE_FORMAT(l.loan_date, "%d/%c/%Y") AS loan_date,
  DATE_FORMAT(l.returned_date, "%d/%c/%Y") AS returned_date,
  DATE_FORMAT(CURDATE(), "%d/%c/%Y") AS actual_returned_date,
  CONCAT('Rp. ', if(DATEDIFF(CURDATE(), l.returned_date) <= 0, 0, 
    DATEDIFF(CURDATE(), l.returned_date) * 
    (select CONVERT(s.sys_val, UNSIGNED INTEGER) 
      from tb_m_system s 
      where s.sys_cat = 'BOOK_LOAN'
            AND s.sys_sub_cat = 'PENALTY_RETURNED'
            AND s.sys_cd = 'PR1'))) AS penalty
  from tb_r_loan l INNER JOIN tb_m_students s ON l.nim = s.nim
       INNER JOIN tb_m_book b ON l.book_cd = b.book_cd
  where l.loan_no = '20200321003'; 